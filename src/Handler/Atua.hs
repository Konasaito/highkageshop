{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Atua where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

serieCB = do
  rows <- runDB $ selectList [] [Asc SerieNome]
  optionsPairs $ 
      map (\r -> (serieNome $ entityVal r, entityKey r)) rows

atorCB = do
  rows <- runDB $ selectList [] [Asc AtorNome]
  optionsPairs $ 
      map (\r -> (atorNome $ entityVal r, entityKey r)) rows

-- renderDivs
formAtua :: Form Atua 
formAtua = renderBootstrap $ Atua
    <$> areq (selectField serieCB) "Serie: " Nothing
    <*> areq (selectField atorCB) "Ator: " Nothing
    <*> areq intField "Ano: " Nothing

    
getAtuaR :: Handler Html
getAtuaR = do 
    (widget,_) <- generateFormPost formAtua
    msg <- getMessage
    defaultLayout $ 
        [whamlet|
            $maybe mensa <- msg 
                <div>
                    ^{mensa}
            
            <h1>
                CADASTRO DE ATUACOES
            
            <form method=post action=@{AtuaR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postAtuaR :: Handler Html
postAtuaR = do 
    ((result,_),_) <- runFormPost formAtua
    case result of 
        FormSuccess atua -> do 
            runDB $ insert atua 
            setMessage [shamlet|
                <div>
                    ATUACAO INCLUIDA
            |]
            redirect AtuaR
        _ -> redirect HomeR

getElencoR :: SerieId -> Handler Html
getElencoR serieid = do 
    let sql = "SELECT ??,??,?? FROM serie \
          \ INNER JOIN atua ON atua.serieid = serie.id \
          \ INNER JOIN ator ON atua.atorid = ator.id \
          \ WHERE serie.id = ?"
    serie <- runDB $ get404 serieid
    atores <- runDB $ rawSql sql [toPersistValue serieid] :: Handler [(Entity Serie,Entity Atua,Entity Ator)]
    defaultLayout $ do 
        [whamlet|
            <h1>
                ELENCO DE #{serieNome serie}
            <ul>
                $forall (Entity _ _, Entity _ _, Entity _ ator) <- atores
                    <li>
                        #{atorNome ator}
        |]
      



