##r154929 | t.fiedler | 2015-04-21 10:01:35 +0200 (Di, 21 Apr 2015) | 7 lines
Bug 57120 - Probleme mit Mailversand aufgrund des asynchronen Sendens von E-Mails.

- Cleaned up IMailSender interface
- Removed HandleMailSendFactory and interface
- Refactor VacationApproval process to use MailDistributor instead of going for HandleMailSend directly
- Slimmed down VacationApproval and remove redundant code
- Introduce thin layer of tests that verify mail sending process upon approval

----------
