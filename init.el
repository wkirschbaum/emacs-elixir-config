;;; init.el --- Init file for a basic Elixir environment -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Wilhelm H Kirschbaum

;; Author           : Wilhelm H Kirschbaum
;; Version          : 1.2
;; URL              : https://github.com/wkirschbaum/emacs-elixir-config
;; Package-Requires : ((emacs "29.1") (elixir-ts-mode "1.2"))
;; Created          : August 2023
;; Keywords         : elixir

;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.

;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.

;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This is a minimal setup for editing Elixir and Heex files.
;;
;; This setup assumes that you have a compatible version of tree-sitter compiled
;; with your Emacs.

;; Known issues

;; When the tree-sitter grammar installs for the first time, it will
;; not enable elixir-ts-mode correctly for the open buffers.  You can
;; close and re-open the buffer to ensure the mode loads correctly.

;;; Code:

(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(progn
  (setq custom-file (concat user-emacs-directory "custom.el"))
  (if (file-exists-p custom-file)
      (load custom-file)))

;; These declarations are only here to
;; squash warnings we get for use-package.
(defvar lsp-keymap-prefix)
(defvar global-treesit-auto-modes)
(defvar treesit-auto-install)
(declare-function global-treesit-auto-mode "")

;; Don't show byte compile warnings
;; because they are mostly uninteresting unless working
;; on Emacs or a package.
(setq byte-compile-warnings nil)

;; Elixir editing mode
(use-package elixir-ts-mode
  :ensure t)

;; Prompts to install the appropriate grammars as well
;; as automatically switching to the -ts-modes.
(use-package treesit-auto
  :ensure t
  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode))

;; LSP
(use-package lsp-mode
  :ensure t
  :hook ((elixir-ts-mode . lsp-deferred)
         (heex-ts-mode . lsp-deferred))
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-keymap-prefix "C-c l")
  (custom-set-variables '(lsp-imenu-sort-methods '(position kind)))
  (custom-set-variables '(lsp-imenu-index-symbol-kinds
                          '(Module Class Constructor Function))))


(provide 'init)
;;; init.el ends here
