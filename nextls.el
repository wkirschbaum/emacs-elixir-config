;;; nextls.el --- description -*- lexical-binding: t; -*-

;; Copyright (C) 2021 emacs-lsp maintainers

;; Author: emacs-lsp maintainers
;; Keywords: lsp, elixir

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; LSP Clients for the Elixir Programming Language.

;;; Code:

(require 'lsp-mode)

(defgroup nextls nil
  "LSP support for Elixir, using elixir-ls."
  :group 'lsp-mode
  :link '(url-link "https://github.com/elixir-tools/next-ls"))

(defcustom lsp-nextls-version "0.6.5"
  "Automatic download url for nextls."
  :type 'string
  :group 'lsp-nextls
  :package-version '(lsp-mode . "8.0.1"))

(defcustom lsp-nextls-download-url
  (format (concat "https://github.com/elixir-tools/next-ls"
                  "/releases/download/v%s/nextls")
          lsp-nextls-version)
  "Automatic download url for nextls."
  :type 'string
  :group 'lsp-nexls
  :package-version '(lsp-mode . "8.0.1"))

(defcustom lsp-nextls-binary-path
  (f-join lsp-server-install-dir
          "nextls"
          "nextls")
  "The path to `nextls' binary."
  :type 'file
  :group 'lsp-nextls
  :package-version '(lsp-mode . "8.0.1"))

(lsp-dependency
 'nextls
 `(:download :url lsp-nextls-download-url
             :store-path ,(f-join lsp-server-install-dir
                                  "nextls"
                                  "nextls")
             :binary-path lsp-nextls-binary-path
             :set-executable? t))

(defcustom lsp-nextls-command '("nextls" "--stdio=true")
  "The command that starts nextls."
  :type '(repeat :tag "List of string values" string)
  :group 'lsp-nextls
  :package-version '(lsp-mode . "8.0.1"))

(lsp-register-client
 (make-lsp-client :new-connection
                  (lsp-stdio-connection
                   (lambda ()
                     `(,(or (executable-find (cl-first lsp-nextls-command))
                            (lsp-package-path 'nextls))
                       ,@(cl-rest lsp-nextls-command))))
                  :activation-fn (lsp-activate-on "elixir")
                  :multi-root t
                  :priority 1
                  :server-id 'nextls
                  :download-server-fn
                  (lambda (_client callback error-callback _update?)
                    (lsp-package-ensure 'nextls callback error-callback))))

(lsp-consistency-check nextls)

(provide 'nextls)
;;; nextls.el ends here
