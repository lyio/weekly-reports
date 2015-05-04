##r155530 | t.fiedler | 2015-04-30 15:47:54 +0200 (Thu, 30 Apr 2015) | 4 lines
Bug 55250 - Enhance the log information

- Removed the inner Dictionary used to map recipient ids to memo texts to prevent DuplicateKeyExceptions and used a MemoContactPerson object instead
- Added a try-catch-block in MailingsSynchronizer to improve logging

----------
