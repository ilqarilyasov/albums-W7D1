//
//  AlbumDetailTableViewController.swift
//  Albums
//
//  Created by Ilgar Ilyasov on 10/8/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class AlbumDetailTableViewController: UITableViewController, SongTableViewCellDelegate {
    
    // MARK: - Properties
    
    let reuseIdentifier = "SongTableCell"
    var albumController: AlbumController?
    var album: Album? { didSet { updateViews()}}
    var tempSongs: [Song] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var artist: UITextField!
    @IBOutlet weak var genre: UITextField!
    @IBOutlet weak var coverURL: UITextField!
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    @IBAction func saveBarButtonTapped(_ sender: Any) {
        
    }

    // MARK: - Update views
    
    func updateViews() {
        if let album = album, isViewLoaded {
            albumName.text = album.name
            artist.text = album.artist
            genre.text = album.genres.joined()
            coverURL.text = album.coverArt.joined()
            tempSongs = album.songs
            
            navigationItem.title = album.name
        } else {
            navigationItem.title = "New Album"
        }
    }
    
    // MARK: - SongTableViewCellDelegate
    
    func addSong(with title: String, duration: String) {
        guard let newSong = albumController?.createSong(duration: duration, name: title) else { return }
        tempSongs.append(newSong)
        tableView.reloadData()
        let indexPath = IndexPath(row: tempSongs.count, section: 0)
        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition(rawValue: indexPath.row)!, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempSongs.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SongTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 140
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
     }
     */
}
