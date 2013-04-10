;;; smtpmail-async --- Send e-mail with smtpmail.el asynchronously

;; Copyright (C) 2012~2013 John Wiegley

;; Author: John Wiegley <jwiegley@gmail.com>
;; Created: 18 Jun 2012
;; Version: 1.0
;; Keywords: email async
;; X-URL: https://github.com/jwiegley/emacs-async

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Send e-mail with smtpmail.el asynchronously.  To use:
;;
;;   (require 'smtpmail-async)
;;
;;   (setq send-mail-function 'async-smtpmail-send-it
;;         message-send-mail-function 'async-smtpmail-send-it)
;;
;; This assumes you already have smtpmail.el working.

(defgroup smtpmail-async nil
  "Send e-mail with smtpmail.el asynchronously"
  :group 'smptmail)

(require 'async)
(require 'smtpmail)

(defun async-smtpmail-send-it ()
  (let ((to (message-field-value "To")))
    (message "Delivering message to %s..." to)
    (async-start
     `(lambda ()
        (require 'smtpmail)
        (with-temp-buffer
          (insert ,(buffer-substring-no-properties (point-min) (point-max)))
          ;; Pass in the variable environment for smtpmail
          ,(async-inject-variables "\\`\\(smtpmail\\|\\(user-\\)?mail\\)-")
          (smtpmail-send-it)))
     `(lambda (&optional ignore)
        (message "Delivering message to %s...done" ,to)))))

(provide 'smtpmail-async)

;;; smtpmail-async.el ends here
