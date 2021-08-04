  autocmd Filetype tex,plaintex inoremap <buffer> ,f <Esc>/<++><CR>:nohlsearch<CR>"_c4l
  autocmd filetype tex,plaintex inoremap <buffer> ,1 \section{}<CR><++><Esc>kf{a
  autocmd filetype tex,plaintex inoremap <buffer> ,2 \subsection{}<CR><++><Esc>kf{a
  autocmd filetype tex,plaintex inoremap <buffer> ,3 \subsubsection{}<CR><++><Esc>kf{a
  autocmd filetype tex,plaintex inoremap <buffer> ,b \textbf{}<++><Esc>4hi
  autocmd filetype tex,plaintex inoremap <buffer> ,i \textit{}<++><Esc>4hi
  autocmd filetype tex,plaintex inoremap <buffer> ,g \begin{figure}[<++>]<CR>\centering<CR>\includegraphics[scale=<++>]{<++>}<CR>\caption{<++>}<CR>\end{figure}<CR><++><Esc>5k
  autocmd filetype tex,plaintex inoremap <buffer> ,t \begin{table}<CR>\centering<CR>\caption{<++>}<CR>\begin{tabular}{<++>}<CR><++><CR>\end{tabular}<CR>\end{table}<CR><++><Esc>7k
  autocmd filetype tex,plaintex inoremap <buffer> ,m \[<CR><CR>\]<CR><CR><++><Esc>3ki
  autocmd filetype tex,plaintex inoremap <buffer> ,e \begin{equation}<CR><CR>\end{equation}<Esc>0kk
  autocmd filetype tex,plaintex inoremap <buffer> <F1> \begin{<++>}<CR><CR>\end{<++>}<Esc>0kk
  " autocmd filetype tex,plaintex nmap <buffer> <F10> :LLPStartPreview<CR>
  " autocmd filetype tex,plaintex nmap <buffer> <F10> :call Tex_ViewLaTeX()<CR>
