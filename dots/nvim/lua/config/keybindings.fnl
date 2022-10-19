(let [wk (require "which-key")]
  (wk.setup {})
  (wk.register {
                :f {
                    :name "telescope"
                    :f ["<cmd>Telescope find_files<CR>" "Find File"]
                    :g ["<cmd>Telescope live_grep<CR>" "Live Grep"]}
                :p ["<cmd>NERDTreeToggle<CR>" "Toggle NERDTree"]
                :s {
                    :name "split"
                    :v ["<cmd>vsp new <CR>" "Vertical"]
                    :h ["<cmd>sp new <CR>" "Horizontal"]}}
    {:prefix "<leader>"})
  (wk.register {
                :g { 
                    :name "navigation"
                    :h ["<cmd>wincmd h<CR>" "Go to left window"]
                    :l ["<cmd>wincmd l<CR>" "Go to right window"] 
                    :k ["<cmd>wincmd k<CR>" "Go to top window"]
                    :j ["<cmd>wincmd j<CR>" "Go to bottom window"]}})) 
