(let [cmp (require "cmp")]
  (cmp.setup.cmdline
    [
     "/"
     {:sources (cmp.config.sources
                 [{:name "buffer"}
                  {:name "nvim_lsp_document_symbol"}])}])
  (cmp.setup
    {
      :snippet
      {
        :expand
        (fn [args]
          ((let [snip (require "luasnip")] (snip.lsp_expand args.body))))}
      :mapping
      {
        "<C-d>" (cmp.mapping.scroll_docs -4)
        "<C-f>" (cmp.mapping.scroll_docs 4)
        "<C-Space>" (cmp.mapping.complete)
        "<C-e>" (cmp.mapping.close)
        "<CR>" (cmp.mapping.confirm { :behavior cmp.ConfirmBehavior.Replace
                                        :select true})
        "<Tab>" (cmp.mapping (cmp.mapping.select_next_item) ["i" "s"])
        "<S-Tab>" (cmp.mapping (cmp.mapping.select_prev_item) ["i" "s"])}
      :sources
      [
        {:name "nvim_lsp"}
        {:name "orgmode"}
        {:name "buffer"}]}))
(let [nvim_lsp (require "lspconfig")
      cmp_nvim_lsp (require "cmp_nvim_lsp")
      servers ["rust_analyzer" "pyright" "tsserver" "elmls" "hls" "purescriptls" "rnix" "gopls" "jdtls" "sqls"]]
  (each [_ server (ipairs servers)] ; not sure how to do this in a cleaner way
    (let [server_to_setup (. nvim_lsp server)]
      (server_to_setup.setup {:capabilities (cmp_nvim_lsp.default_capabilities)}))))
(vim.cmd "autocmd BufWritePre *.rs,*.java,*.elm lua vim.lsp.buf.formatting()")
(vim.cmd "autocmd BufWritePre *.js,*.ts,*.tsx,*.jsx Neoformat prettier")
