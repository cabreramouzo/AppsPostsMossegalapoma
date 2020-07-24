//
//  DocumentParser.swift
//  documentPicker
//
//  Created by MAC on 22/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
import SwiftSoup

import Ink

func parseMarkdown(inputString: String) {
    
    let md: String =

        """
proposta plantilla 2

  


Programa 445

tot el text s’ignora excepte els textos encapsulats dins de:

  * %extracte% bla bla bla %extracte%
  * %part1% bla bla bla %part1%
  * %part2% bla bla bla %part2%
  * %propostes% bla bla bla %propostes%
  * %trukis% bla bla bla %trukis%

Tinc [un text que no es un link]

Llavors aixo quedaria igual excepte que les parts que volem que vagin al post, les encapsulem amb els tags descrits anteriorment. Per cert, es poden usar més d’un cop una parella de tags, és a dir podem posar extracte, després dir un bla bla i de nou extracte.

  


  


DIMARTS xx de xx de 2020

TEMÀTICA:

CONVIDATS: Josep Ruano

Lloc de gravació: LISA

  


Mossegalapoma, fem podcàsting des del 2007 - Amb la col·laboració de la Universitat Politècnica de Catalunya.

  


INTRO 1

Tomàs

  


%propostes%

  * (Tomàs - podcast) Un nou podcast de ciència i en català, tot just acaba de nàixer de la mà de la Marta Vila, comunicadora científica, mèdica i ambiental de la UPF. Aquí teniu el seu [primer programa pilot](https://www.ivoox.com/l-039-analisi-dades-massives-medicina-amb-clara-audios-mp3_rf_52552259_1.html).
  * (Josep - Mercat) [Mercatarrells.com](http://Mercatarrells.com) per unir pagesos amb consumidors.

%propostes%

  


Avui fem la cloenda oficial d’aquesta temporada 13. %extracte% Tanquem per vacances. I ho fem amb un convidat d’excepció, amb en Josep Ruano %extracte% i els habituals de mossegalapoma….

  


Intentarem tenir avui una mirada llarga sobre la tecnologia, la crisi del covid i, el que es pitjor, una detectable crisi de confiança.

  


%extracte%

Tindrem una mirada llarga sobre la tecnologia, la crisi del COVID i, el que és pitjor, una detectable crisi de confiança.

%extracte%

  


Tot i això i més en aquest episodi 445, temporada 13 de mossegalapoma. Comencem

  


  


INTRO 2

Tomàs

Temes principals amb Josep Ruano

  


%part1%

  


Prèvia parlant d'Apple i els processadors Apple Silicon (ARM).

Blog d'en [Josep Ruano](https://josepruano.com/).

Crisis entrellaçades i la crisi de confiança.

  


%part1%

  


  


En els teus dos darrers articles [al teu blog](https://josepruano.com/), que enllacem a les notes del programa, parles amb detall sobre la desconfiança.

  


El segon punt de conversa és com veus, centrant-nos en els efectes de la tecnologia i la societat, el moment actual dins la crisi actual i futura de la Covid-19 i d’altres crisis entrellaçades.
"""
    
let propostes =
"""

  %propostes%

  * (Josep - Documental) caca A Amazon Prime “La Telaraña, el segundo imperio británico”. propostes
  * (SinneBOFH - samarreta mossegui) “Jo també me foto cops de cap a la paret mentre escolto mossegalapoma” :D
  * (M.Rabell - Alternativa Evernote) “[Notion](https://www.notion.so/)”, una alternativa molt potent a Evernote, amb markdown, bases de dades, wikis, tasques, kanban, etc.
  * (Txabat - pel·lícula) “The Loundromat” basada en els paper de Panamà de les societats Offshore.

  %propostes%

  """
    
    let md2 =
    """


CONTACTA

Tomàs

  


L’AIXETA <https://mossegalapoma.aixeta.cat/ca>

  


Agraïm als nous mecenes que s’han afegit a ajudar, amb les seves aportacions regulars, a tirar endavant aquest, el vostre projecte:

      *


  


DONATIUS VIA PAYPAL

      *


  


COMENTARIS A iTUNES

      *


  


  


  


Tomàs

NOTÍCIES BREUS

  


%part2%

  


Twitch suspèn temporalment el compte de Donald Trump per conducta d’incitació a l’odi.  ([The Verge](https://www.theverge.com/2020/6/29/21307145/twitch-donald-trump-ban-campaign-account)).

  


Reddit el·limina 200 fòrums de trolls, 1800 inactius i també el fòrum més popular de seguidors de Trump amb 790.000 participants. ([The Verge)](https://www.theverge.com/2020/6/29/21304947/reddit-ban-subreddits-the-donald-chapo-trap-house-new-content-policy-rules).

  


  


Amsterdam prohibeix Airbnb, i d’altres serveis similars, al centre d’Amsterdam i a la resta de la ciutat el lloguer es restringeix a un màxim de 30 dies per any, un màxim de 4 hostes cada cop  i sota llicència específica. La multa per llogar un apartament sense permís de l’ajuntament serà de 20.750 €. ([DutchNews.nl](https://www.dutchnews.nl/news/2020/04/amsterdam-to-ban-airbnb-in-city-centre-bring-in-permits-for-holiday-rentals/))

  


La NPR ha fet una [breu entrevista al CEO de Airbnb](https://www.npr.org/2020/04/28/846939553/airbnb-rental-model-becomes-a-victim-of-the-coronavirus?t=1593505260526), que ha hagut de posposar la seva sortida a borsa pel greu impacte de la pandèmia.

  


El govern suís ha alliberat l’aplicació de seguiment de contactes de la COVID-19 i la gent de [ProtonMail ha comentat en un fil a twitter](https://twitter.com/protonmail/status/1277241985749876737?s=12) alguns aspectes. En concret destaca que l’ús de Bluetooth fa als usuaris vulnerables pel seguiment que en pot fer Google en els telèfons Android.

  


%part2%

  


  


  


PROPOSTES

%propostes%

  


  * (Àlex Corretgé - YouTube) Una experiència molt divertida que han fet família i amics a YouTube durant el temps de confinament dins EMTV (Empordanet Televisió). On fan [gales d’eurovisió particulars](https://youtu.be/9fhddMsRMX0). La darrera dedicada al col·lectiu LGTBIQ+ - També a [Spotify](https://open.spotify.com/playlist/6mo82MwB0zFIvgRuEq5k3z?si=_iB2xdpDTHmJzoi-4oo4sQ).
  * (SinnerBOFH - col·laboració) Ens demana que fem un episodi amb l’OscarApple, a rel d’una consulta/conversa al canal de Telegram sobre el món de les càmeres IP de vigilància domèstica.
  * (Dani Gaya - App esportiva) “Waterspeed” ideal per enregistrar tota mena d’esports aquàtics.

  


%propostes%

  


  


TRUKIS MOSSEGUIS

%trukis%

  


  *   iOS: Desinstalar una app sense perdre la seva info: Anem a Ajustaments > General > Emmagatzemament del dispositiu > Desinstalar App.
  * Pel JRUANO: <https://www.faq-mac.com/2020/01/copia-de-seguridad-ios-en-tu-nas/>

  


%trukis%

OUT CURT

  


Tomàs

Gràcies a tots per la vostra atenció, ens retrobem la setmana vinent on parlarem amb xxxxxxxxxxxxxxxx sobre …..

  



"""

    var mdparser = MarkdownParser()
    let html = mdparser.html(from: propostes)
    print(html)
    
    
    
    //clean and search for XSS vulnerability
    
}
