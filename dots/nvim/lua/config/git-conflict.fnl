(let [ git_conflict (require "git-conflict")]
  (git_conflict.setup {
                       :default_mappings true
                       :highlights {:incoming  "DiffText"
                                    :current "DiffAdd"}}))
