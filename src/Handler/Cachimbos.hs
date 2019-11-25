{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Cachimbos where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- renderDivs
formAtor :: Form Cachimbos 
formAtor = renderBootstrap $ Ator
    <$> areq textField "Nome: " Nothing
    <*> areq dayField "Nasc: " Nothing

getAtorR :: Handler Html
getAtorR = do 
    (widget,_) <- generateFormPost formCachimbos
    msg <- getMessage
    defaultLayout $ 
        [whamlet|
            $maybe mensa <- msg 
                <div>
                    ^{mensa}
            
            <h1>
                CADASTRO DE CACHIMBOS
            
            <form method=post action=@{CachimbosR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postAtorR :: Handler Html
postAtorR = do 
    ((result,_),_) <- runFormPost formCachimbos
    case result of 
        FormSuccess cachimbos -> do 
            runDB $ insert cachimbos 
            setMessage [shamlet|
                <div>
                    CACHIMBO INCLUIDO
            |]
            redirect CachimbosR
        _ -> redirect HomeR






