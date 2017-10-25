anonymize_text = function(fpath, enc="UTF-8"){
    lines = readLines(fpath, encoding=enc)
    e1 = new.env()
    ano_lines = lapply(lines, function(x){anonymize(x, e1)})
    ano_lines = ano_lines[!is.na(ano_lines)]
    ano_fpath = gsub("\\.(\\w+)", ".anony.\\1", fpath)
    ano_texts = paste(ano_lines, collapse="\n")
    ano_conn = file(ano_fpath, encoding="UTF-8")
    writeLines(ano_texts, ano_conn)
    close(ano_conn)
}

anonymize = function(x, env){
    m = regexec("^. (\\w+): .*$", x, perl=T)
    if (m[[1]][1] < 0){
        return(x)
    }
    tok = regmatches(x, m)[[1]]
    if (!(exists("user_map", envir=env))){
        assign("user_map", list(), envir=env)
    }
    if(!(tok[2] %in% names(env$user_map))){
        env$user_map[[tok[2]]] = sprintf("user%03d", length(env$user_map)+1)        
    }

    new_x = gsub(tok[2], env$user_map[tok[2]], x)
    new_x = substr(new_x, 1, nchar(new_x)-12)
    return(new_x)
}

