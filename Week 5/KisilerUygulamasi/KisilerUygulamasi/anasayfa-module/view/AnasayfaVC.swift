//
//  ViewController.swift
//  KisilerUygulamasi
//
//  Created by Deniz Yüce on 17.04.2022.
//

import UIKit

//class AnasayfaVC: UIViewController, UISearchBarDelegate {
class AnasayfaVC: UIViewController {
    //eğer bir delegate in varsa ona uygun extension yaz öyle kullan

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var kisilerTableView: UITableView!
    
    var kisilerListe = [Kisiler]()
    
    var anasayfaPresenterNesnesi:ViewToPresenterAnasayfaProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // sayfa yüklendiğinize yetki vericez search bar resim nesnesine
        searchBar.delegate = self
        //delegate işlemleri
        //bir protokol işlemi varsa yetkilendirilmeden çalışmaz
        //protokol -> sınıflara özellik için eklediğimiz yapılar
        //bize fonksiyon veriyorlar, bu fonksiyonları kullanmak zorundayız
        //kalıtımdan farklı, override yazmaz
        kisilerTableView.delegate = self
        kisilerTableView.dataSource = self
        //amacı: tableview ü aşağıdaki extension a bağlamak
        
        AnasayfaRouter.createModule(ref: self)
        
        anasayfaPresenterNesnesi?.kisileriYukle()
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let kisi = sender as? Kisiler {
                let gidilecekVC = segue.destination as! KisiDetayVC
                gidilecekVC.kisi = kisi
            }
        }
    }
    
    
}

//EXTENSION ÖNEMLİ
//ARAYÜZÜ SADELEŞTİRİR
//eğer bir delegate in varsa ona uygun extension yaz öyle kullan
extension AnasayfaVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        anasayfaPresenterNesnesi?.ara(aramaKelimesi: searchText)
    }
}

//table view --> alt alta görsel gösterme
//collection view --> kutucuklu yapı (ikili ikili)

extension AnasayfaVC : PresenterToViewAnasayfaProtocol {
    func viewaVeriGonder(kisilerListesi: Array<Kisiler>) {
        self.kisilerListe = kisilerListesi
        self.kisilerTableView.reloadData() //arayüzü güncellemek * * * * * * * *
    }
}

extension AnasayfaVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 5 //5 taneri veri göstereceksin anlamına gelir
        //dynamic olması için:
        return kisilerListe.count
    }
    
    //CELL kodlaması
    // ne yazıcam, ne göstericek, ne yazıcak
    
    //indexPath ÖNEMLİ --> çalıştığı kadar index bilgisini verir
    //ilk çalıştığında 0 vericek, sonra 2 sonra 3...
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kisi = kisilerListe[indexPath.row]
        
        let hucre = tableView.dequeueReusableCell(withIdentifier: "kisilerHucre", for: indexPath) as! TableViewCell
        
        hucre.kisiBilgiLabel.text = "\(kisi.kisi_ad!) - \(kisi.kisi_tel!)"
        
        return hucre
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil") {
            (action, view, void) in
            let kisi = self.kisilerListe[indexPath.row]  //erişim sıkıntısı olursa self ekliyoruz
            
            
            let alert = UIAlertController(title: "Silme işlemi", message: "\(kisi.kisi_ad!) silinsin mi?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel) {action in}
            alert.addAction(iptalAction)
            
            let evetAction = UIAlertAction(title: "Evet", style: .destructive) {action in
                self.anasayfaPresenterNesnesi?.sil(kisi_id: kisi.kisi_id!)
            }
            alert.addAction(evetAction)
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [silAction]) //kaç tane action ımız varsa onları yazıyoruz
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let kisi = kisilerListe[indexPath.row]
        //print("\(kisi.kisi_ad!) seçildi")
        performSegue(withIdentifier: "toDetay", sender: kisi)
        tableView.deselectRow(at: indexPath, animated: true) //seçili kalmasın diye
    }
}
