//
//  ContatoreViewController.swift
//  ContoAllaRovescia
//
//  Created by riccardo silvi on 22/03/18.
//  Copyright © 2018 riccardo silvi. All rights reserved.
//

import UIKit

class ContatoreViewController: UIViewController {
    
    //istanza di Timer
    var timer = Timer()
    
    //il tempo con cui inizierà il conteggio
    var tempo = 30
    
    //la label che mostra lo scorrimento del tempo all'utente
    @IBOutlet var contatore: UILabel!
    //outlet per la label con la quantità di tempo da aumentare
    @IBOutlet var unitaTempo: UILabel!
    //stack aggiunta secondi con Timer attivo
    @IBOutlet var stackAggiungiTempo: UIStackView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /***Gestione elementi UI***/
        
        //nascondi la stack modifica timer in fase di attività
        stackAggiungiTempo.isHidden = true
        
        //attivazione interazione utente per le label
        contatore.isUserInteractionEnabled = true
        unitaTempo.isUserInteractionEnabled = false
    
        /***Creazione e assegnazione delle SwipeGestures***/
        
        //a) PER LA LABEL UNITA TEMPO
        
        //Swipe Destro
        let swipeUnitaTempoDestro = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(sender:)))
        swipeUnitaTempoDestro.direction = .right
        
        //Swipe Sinistro
        let swipeUnitaTempoSinistro = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(sender:)))
        swipeUnitaTempoSinistro.direction = .left
        
        //b) PER LA LABEL CONTATORE
       
        //Swipe Destro
        let swipeContatoreDestro = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(sender:)))
        swipeContatoreDestro.direction = .right
        
        //Swipe Sinistro
        let swipeContatoreSinistro = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(sender:)))
        swipeContatoreSinistro.direction = .left
        
        //Assegnazione delle gesture alle label
        unitaTempo.addGestureRecognizer(swipeUnitaTempoDestro)
        unitaTempo.addGestureRecognizer(swipeUnitaTempoSinistro)
        
        contatore.addGestureRecognizer(swipeContatoreDestro)
        contatore.addGestureRecognizer(swipeContatoreSinistro)
      
    }
    
    // MARK: - Metodo ciclico del Timer
    
    //la funzione che ciclerà allo scorrere di ogni secondo
    @objc func diminuisciTimer() {
        //se il tempo è maggiore di zero
        if tempo > 0 {
            //togli un unità
            tempo -= 1
        } else {
            //altrimenti interrompi il timer
            timer.invalidate()
            //resetta il tempo a 30
            tempo = 30
            //e il valore nella label "unitaTempo"
            unitaTempo.text = "15"
            gestisciAttivazioneUIPerGestureEStack()
        }
        //e aggiorna il testo della label "contatore"
        contatore.text = String(tempo)
    }
    
    //MARK: - IBActions
    
    @IBAction func bottonePausaPremuto(_ sender: Any) {
        //interrompe il timer e gestisce l'UI
        timer.invalidate()
        gestisciAttivazioneUIPerGestureEStack()
        
    }
    
    @IBAction func bottoneStartPremuto(_ sender: Any) {
        
        //per assicurarci un normale funzionamento del timer
        //controlliamo che non sia già attivo
        if !timer.isValid{
            //definiamo le caratteristiche del Timer
            //ad intervalli di 1 secondo eseguirà la func decreaseTimer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ContatoreViewController.diminuisciTimer), userInfo: nil, repeats: true)
            
            gestisciAttivazioneUIPerGestureEStack()
            
        } else {//altrimenti comunichiamo in console..
            print("Timer già attivo")
        }
    }
    
    @IBAction func bottoneMenoPremuto(_ sender: UIButton) {
        //sottrae ove matematicamente possibile
        //al valore Intero di Contatore il valore di "tempo"
        //e aggiorna il valore sulla label contatore
        contatore.sottraiValoreInt(di: unitaTempo, da: &tempo)
    }
    
    @IBAction func bottonePiuPremuto(_ sender: UIButton) {
        //somma al valore Intero di Contatore il valore di "tempo"
        //e aggiorna il valore sulla label contatore
        contatore.sommaValoreInt(di: unitaTempo, a: &tempo)
        
    }
    
    @IBAction func bottoneResetPremuto(_ sender: Any) {
        //fermiamo il timer attuale
        timer.invalidate()
        //resetta il tempo al valore iniziale
        tempo = 30
        //e aggiorna la label
        contatore.text = String(tempo)
        unitaTempo.text = "15"
        gestisciAttivazioneUIPerGestureEStack()
    }

    //MARK: - Metodo gestione SwipeGestures
    
    //funzione che si attiverà ogni volta che verrà eseguito swipe destro/sinistra
    @objc func swipeGesture(sender: UIGestureRecognizer) {
        //se il parametro immesso come sender è un UISwipeGestureRecognizer
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            //azioni per le varie direzioni
            switch swipeGesture.direction {
            //DESTRA
            case UISwipeGestureRecognizerDirection.right :
                //agisci in base allo stato di attività del timer
                timer.isValid ? unitaTempo.somma(5) : contatore.somma(15); tempo  = Int(contatore.text!)!
            //SINISTRA
            case UISwipeGestureRecognizerDirection.left :
                //agisci in base allo stato di attività del timer
                if timer.isValid {//se timer attivo
                    unitaTempo.sottrai(5)
                } else {
                    contatore.sottrai(15)
                    tempo = Int(contatore.text!)!
                }
            default : break
            }
        } else {
            print("Sender non è UISwipeGestureRecognizer")
        }
    }
    
    //MARK: - Metodi modifica UI
    
    ///in base all'attività del Timer modifica l'UI
    func gestisciAttivazioneUIPerGestureEStack(){
        if timer.isValid {
            contatore.isUserInteractionEnabled = false
            unitaTempo.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5) {
                self.stackAggiungiTempo.isHidden = false
            }
        } else {
            contatore.isUserInteractionEnabled = true
            unitaTempo.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5) {
                self.stackAggiungiTempo.isHidden = true
            }
        }
    }
    
}

/***ESTENSIONE UILABEL PER OPERAZIONI***/

extension UILabel {
    
    
    func sottraiValoreInt(di valoreDiff: UILabel, da tempo: inout Int){
        
        //se il tempo restante è maggiore di quello nella label
        if let tempoDifferenza = Int(valoreDiff.text!), tempo > tempoDifferenza {
            
            //sottrae n secondi al timer
            tempo -= tempoDifferenza
            //e aggiorna la label dedicata per l'utente
            self.text = String(tempo)
        }

    }
    
    func sottrai(_ cifra : Int){
        //se il tempo restante è maggiore di quello nella label
        if let tempoDifferenza = Int(self.text!), tempoDifferenza > cifra {
            
            //sottrae n secondi al timer
            let nuovoTempo = tempoDifferenza - cifra
            //e aggiorna la label dedicata per l'utente
            self.text = String(nuovoTempo)
        }
    }
    
    
    func somma(_ cifra: Int){
        if let tempoSomma = Int(self.text!) {
            //aggiunge secondi tanti quanti contenuti nella label
           let somma = tempoSomma + cifra
            //e aggiorna la label dedicata per l'utente
            self.text = String(somma)
        }
    }
    
    
    func sommaValoreInt(di valoreSomma: UILabel, a tempo: inout Int) {
        //dato il valore Int da sommare
        if let tempoSomma = Int(valoreSomma.text!) {
            //aggiunge tale valore
            tempo += tempoSomma
            //e aggiorna la label dedicata per l'utente
            self.text = String(tempo)
        }
    }
    

    
    
}

