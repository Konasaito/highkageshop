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
formCachimbos :: Form Cachimbos 
formCachimbos = renderBootstrap $ Cachimbos
    <$> areq textField "Nome: " Nothing
    <*> areq intField  "Preco: " Nothing
    <*> areq textField "Material: " Nothing
    
getCachimbosR :: Handler Html
getCachimbosR = do 
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

postCachimbosR :: Handler Html
postCachimbosR = do 
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






