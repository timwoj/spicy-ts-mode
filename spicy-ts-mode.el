;;; spicy-ts-mode.el --- Basic major-mode for Spicy using tree-sitter-spicy -*- lexical-binding: t -*-

;;; Commentary:
;; This is a very rough major-mode for Emacs to enable code highlighting.  It
;; depends on tree-sitter-spicy being installed in a way that Emacs can use
;; it.  Mastering Emacs has a useful guide for how to set that up.
;;
;; It's most-definitely missing some keywords here and there, and I'll probably
;; be updating it as I get more into Spicy.

;;; Code:

(defcustom spicy-indent-offset 4
  "Number of spaces for each indentation step in `spicy-ts-mode'."
  :version "0.1"
  :type 'integer
  :safe 'intergerp)

(defvar spicy--treesit-font-lock-rules
  (treesit-font-lock-rules

   :language 'spicy
   :feature 'comment
   '((comment) @font-lock-comment-face)

   :language 'spicy
   :feature 'string
   '(((string) @font-lock-string-face)
     ((string) @contextual)  ; Contextual special treatment.
     ((char) @font-lock-string-face)
     )

   :language 'spicy
   :feature 'keyword
   '((type_decl ("type") @font-lock-keyword-face)
     (module_decl ("module") @font-lock-keyword-face)
     (enum_decl ("enum") @font-lock-keyword-face)
     (enum_decl ("type") @font-lock-keyword-face)
     (function_decl ("function") @font-lock-keyword-face)
     (hook_decl ("on") @font-lock-keyword-face)
     (hook_decl name: (hook_name) @font-lock-keyword-face)
     (field_decl skip: (is_skip) @font-lock-keyword-face)
     (sink_decl ("sink") @font-lock-keyword-face)
     (struct_decl ("struct") @font-lock-keyword-face)
     (var_decl (linkage) @font-lock-keyword-face)
     ((visibility) @font-lock-keyword-face)
     ((continue) @font-lock-keyword-face)
     ((break) @font-lock-keyword-face)
     (attribute attribute_name: (attribute_name) @font-lock-keyword-face)
     (bitfield ("bitfield") @font-lock-keyword-face)
     (throw_ ("throw") @font-lock-keyword-face)
     (while ("while") @font-lock-keyword-face)
     (return ("return") @font-lock-keyword-face)
     (foreach ("foreach") @font-lock-keyword-face)
     (for ("for") @font-lock-keyword-face)
     (assert ("assert") @font-lock-keyword-face)
     (delete ("delete") @font-lock-keyword-face)
     (print ("print") @font-lock-keyword-face)
     (return ("return") @font-lock-keyword-face)
     (if ("if") @font-lock-keyword-face)
     (unset ("unset") @font-lock-keyword-face)
     (unit_switch ("switch") @font-lock-keyword-face)
     (switch ("switch") @font-lock-keyword-face)
     (contains ("in") @font-lock-keyword-face)
     (contains_not ("!in") @font-lock-keyword-face)
     (case ("case") @font-lock-keyword-face)
     (case ("default") @font-lock-keyword-face)
     )

   :language 'spicy
   :feature 'preprocessor
   '((import ("import") @font-lock-preprocessor-face))

   :language 'spicy
   :feature 'constant
   '(((boolean) @font-lock-constant-face)
     ((bytes) @font-lock-constant-face)
     ((char) @font-lock-constant-face)
     (unit_switch_case (expression) @font-lock-constant-face)
     )

   ;; These could be font-lock-number-face but that face is nil by default
   :language 'spicy
   :feature 'number
   '(((integer) @font-lock-constant-face)
     ((real) @font-lock-constant-face))

   :language 'spicy
   :feature 'type
   '((type_decl name: (ident) @font-lock-type-face)
     (field_decl type_: (void) @font-lock-type-face)
     (typename (ident) @font-lock-type-face)
     (cast (ident) @font-lock-type-face)
     (enum_decl name: (ident) @font-lock-type-face)
     ("unit" @font-lock-type-face)
     (parameterized_type (["iterator" "optional" "result" "set" "tuple" "vector" "view"]) @font-lock-type-face)
     )

   :language 'spicy
   :feature 'variable
   '((field_decl name: (ident) @font-lock-variable-name-face)
     (enum_label name: (ident) @font-lock-variable-name-face)
     (bitfield_field name: (ident) @font-lock-variable-name-face)
     (var_decl name: (ident) @font-lock-variable-name-face)
     (params (ident) @font-lock-variable-name-face)
     (function_arg arg: (ident) @font-lock-variable-name-face)
     )

   :language 'spicy
   :feature 'function-name
   '((function_decl name: (ident) @font-lock-function-name-face))
   )

  ;; Other faces that aren't currently covered here but could be:
  ;; font-lock-function-call-face
  ;; font-lock-variable-use-face
  ;; font-lock-comment-delimiter-face
  ;; font-lock-doc-face
  ;; font-lock-negation-char-face
  ;; font-lock-operator-face
  ;; font-lock-property-name-face (this could be used instead of variable-name-face in some places)
  ;; font-lock-property-use-face
  ;; font-lock-bracket-face

  "Spicy font-lock settings.")

(define-derived-mode spicy-ts-mode prog-mode "Spicy"
  "A mode for the Spicy programming language."
  (unless (treesit-ready-p 'spicy)
    (error "Tree-sitter for Spicy is not available"))

  (treesit-parser-create 'spicy)

  (setq-local comment-start "# ")
  (setq-local comment-end "")
  (setq-local comment-start-skip (rx "#" (* (syntax whitespace))))

  (setq-local treesit-font-lock-settings spicy--treesit-font-lock-rules)
  (setq-local treesit-font-lock-feature-list
              '((comment string constant number)
                (keyword preprocessor)
                (type variable function-name)))

  (treesit-major-mode-setup))

(provide 'spicy-ts-mode)

;;; spicy-ts-mode.el ends here
