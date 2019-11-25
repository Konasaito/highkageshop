{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Ator where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- renderDivs
formAtor :: Form Ator 
formAtor = renderBootstrap $ Ator
    <$> areq textField "Nome: " Nothing
    <*> areq dayField "Nasc: " Nothing

getAtorR :: Handler Html
getAtorR = do 
    (widget,_) <- generateFormPost formAtor
    msg <- getMessage
    defaultLayout $ 
        [whamlet|
            $maybe mensa <- msg 
                <div>
                    ^{mensa}
            
            <h1>
                CADASTRO DE ATOR
            
            <form method=post action=@{AtorR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postAtorR :: Handler Html
postAtorR = do 
    ((result,_),_) <- runFormPost formAtor
    case result of 
        FormSuccess ator -> do 
            runDB $ insert ator 
            setMessage [shamlet|
                <div>
                    ATOR INCLUIDO
            |]
            redirect AtorR
        _ -> redirect HomeR






