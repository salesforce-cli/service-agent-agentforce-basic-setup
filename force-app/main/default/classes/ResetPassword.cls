public with sharing class ResetPassword {
    public class Request {
        @InvocableVariable(required=true)
        public Id userId; // May be User.Id, Contact.Id, or Person Account Id
    }

    public class Result {
        @InvocableVariable
        public Id userId; // Original input Id
        @InvocableVariable
        public Boolean success;
        @InvocableVariable
        public String message;
    }

    // Resolve a community user's User record from an input Id that may be:
    // - User (005) -> return that User (must be active)
    // - Contact (003) -> find active user with ContactId
    // - Person Account (001 + IsPersonAccount) -> use Account.PersonContactId to find active user
    // Returns null if no active user found or input type unsupported.
    private static User resolveCommunityUser(Id anyId) {
        if (anyId == null) return null;
        String prefix = String.valueOf(anyId).substring(0, 3);

        if (prefix == '005') {
            List<User> u = [
                SELECT Id, IsActive, UserType, ContactId
                FROM User
                WHERE Id = :anyId
                AND IsActive = true
                LIMIT 1
            ];
            return u.isEmpty() ? null : u[0];
        } else if (prefix == '003') {
            List<User> u = [
                SELECT Id, IsActive, UserType, ContactId
                FROM User
                WHERE ContactId = :anyId
                AND IsActive = true
                ORDER BY Id
                LIMIT 1
            ];
            return u.isEmpty() ? null : u[0];
        } else if (prefix == '001') {
            Account acc = [
                SELECT Id, IsPersonAccount, PersonContactId
                FROM Account
                WHERE Id = :anyId
                LIMIT 1
            ];
            if (acc != null && acc.IsPersonAccount && acc.PersonContactId != null) {
                List<User> u = [
                    SELECT Id, IsActive, UserType, ContactId
                    FROM User
                    WHERE ContactId = :acc.PersonContactId
                    AND IsActive = true
                    ORDER BY Id
                    LIMIT 1
                ];
                return u.isEmpty() ? null : u[0];
            }
            return null;
        }
        return null;
    }

    @InvocableMethod(label='Reset User Password' description='Triggers a password reset email for the provided User Id(s) or related Contact/Person Account Id(s).')
    public static List<Result> resetUserPassword(List<Request> requests) {
        List<Result> results = new List<Result>();
        if (requests == null) {
            return results;
        }

        // Process each request independently (Flow-safe, bulkified)
        for (Request r : requests) {
            Result res = new Result();
            res.userId = (r != null) ? r.userId : null;
            try {
                if (r == null || r.userId == null) {
                    res.success = false;
                    res.message = 'Id is required.';
                } else {
                    User resolved = resolveCommunityUser(r.userId);
                    if (resolved == null) {
                        res.success = false;
                        res.message = 'No active community user found for the provided Id.';
                    } else {
                        System.resetPassword(resolved.Id, true);
                        res.success = true;
                        res.message = 'Password reset initiated.';
                    }
                }
            } catch (Exception e) {
                res.success = false;
                res.message = 'Failed to reset password.';
                System.debug(LoggingLevel.ERROR, 'ResetPassword error for inputId=' + res.userId + ': ' + e.getMessage());
            }
            results.add(res);
        }
        return results;
    }
}
