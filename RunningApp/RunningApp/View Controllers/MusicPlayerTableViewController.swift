//
/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import MediaPlayer
import AVFoundation

class MusicPlayerTableViewController: UITableViewController {
  
  @IBOutlet var musicTableView: UITableView!
  
 // let myTableView: UITableView = UITableView( frame: CGRect.zero, style: .grouped )
  
  var albums: [AlbumInfo] = []
  var songQuery: SongQuery = SongQuery()
  var audio: AVAudioPlayer?
  var songs: [MPMediaItem] = []
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    self.title = "Albums"
    MPMediaLibrary.requestAuthorization { (status) in
      if status == .authorized {
        self.albums = self.songQuery.get(songCategory: "")
        self.songs = MPMediaQuery.songs().items!
        print("lol1")
        print(self.songs)
        print(self.albums)
        print("lol2")
        DispatchQueue.main.async {
          self.tableView?.rowHeight = UITableViewAutomaticDimension;
          self.tableView?.estimatedRowHeight = 60.0;
          self.tableView?.reloadData()
        }
      } else {
        self.displayMediaLibraryError()
      }
    }
  }
  
  
  func displayMediaLibraryError() {
    
    var error: String
    switch MPMediaLibrary.authorizationStatus() {
    case .restricted:
      error = "Media library access restricted by corporate or parental settings"
    case .denied:
      error = "Media library access denied by user"
    default:
      error = "Unknown error"
    }
    
    let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
      } else {
        // Fallback on earlier versions
      }
    }))
    present(controller, animated: true, completion: nil)
  }
  
  override func didReceiveMemoryWarning() {
    
    super.didReceiveMemoryWarning()
    
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return albums.count
  }
  
  override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int  {
    
    return albums[section].songs.count
  }
  
  override func tableView( _ tableView: UITableView, cellForRowAt indexPath:IndexPath ) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "MusicPlayerCell",
      for: indexPath) as! MusicPlayerCell
    cell.title?.text = albums[indexPath.section].songs[indexPath.row].songTitle
    cell.detail?.text = albums[indexPath.section].songs[indexPath.row].artistName
    let songId: NSNumber = albums[indexPath.section].songs[indexPath.row].songId
    let item: MPMediaItem = songQuery.getItem( songId: songId )
    
    if  let imageSound: MPMediaItemArtwork = item.value( forProperty: MPMediaItemPropertyArtwork ) as? MPMediaItemArtwork {
      //cell.imageMusic?.image = imageSound.image(at: CGSize(width: cell.imageMusic.frame.size.width, height: cell.imageMusic.frame.size.height))
    }
    return cell;
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    return albums[section].albumTitle
  }
  
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
