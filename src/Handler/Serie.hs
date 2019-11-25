{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Serie where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- renderDivs
formSerie :: Form Serie 
formSerie = renderBootstrap $ Serie
    <$> areq textField "Nome: " Nothing
    <*> areq intField  "Ano: " Nothing
    <*> areq textField "Pais: " Nothing

getSerieR :: Handler Html
getSerieR = do 
    (widget,_) <- generateFormPost formSerie
    msg <- getMessage
    defaultLayout $ 
        [whamlet|
            $maybe mensa <- msg 
                <div>
                    ^{mensa}
            
            <h1>
                CADASTRO DE SERIE
            
            <form method=post action=@{SerieR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postSerieR :: Handler Html
postSerieR = do 
    ((result,_),_) <- runFormPost formSerie
    case result of 
        FormSuccess serie -> do 
            runDB $ insert serie 
            setMessage [shamlet|
                <div>
                    SERIE INCLUIDO
            |]
            redirect SerieR
        _ -> redirect HomeR






