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

import Foundation
import MediaPlayer

struct SongInfo {
  
  var albumTitle: String
  var artistName: String
  var songTitle:  String
  
  var songId   :  NSNumber
}

struct AlbumInfo {
  
  var albumTitle: String
  var songs: [SongInfo]
}

class SongQuery {
  
  func get(songCategory: String) -> [AlbumInfo] {
    
    var albums: [AlbumInfo] = []
    let albumsQuery: MPMediaQuery
    if songCategory == "Artist" {
      albumsQuery = MPMediaQuery.artists()
      
    } else if songCategory == "Album" {
      albumsQuery = MPMediaQuery.albums()
      
    } else {
      albumsQuery = MPMediaQuery.songs()
    }
    
    
    // let albumsQuery: MPMediaQuery = MPMediaQuery.albums()
    let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
    //  var album: MPMediaItemCollection
    
    for album in albumItems {
      
      let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
      // var song: MPMediaItem
      
      var songs: [SongInfo] = []
      
      var albumTitle: String = ""
      
      for song in albumItems {
        if songCategory == "Artist" {
          albumTitle = song.value( forProperty: MPMediaItemPropertyArtist ) as! String
          
        } else if songCategory == "Album" {
          albumTitle = song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String
          
          
        } else {
          albumTitle = song.value( forProperty: MPMediaItemPropertyTitle ) as! String
        }
        
        let songInfo: SongInfo = SongInfo(
          albumTitle: song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String,
          artistName: song.value( forProperty: MPMediaItemPropertyArtist ) as! String,
          songTitle:  song.value( forProperty: MPMediaItemPropertyTitle ) as! String,
          songId:     song.value( forProperty: MPMediaItemPropertyPersistentID ) as! NSNumber
        )
        songs.append( songInfo )
      }
      
      let albumInfo: AlbumInfo = AlbumInfo(
        
        albumTitle: albumTitle,
        songs: songs
      )
      
      albums.append( albumInfo )
    }
    
    return albums
    
  }
  
  func getItem( songId: NSNumber ) -> MPMediaItem {
    
    let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )
    
    let query: MPMediaQuery = MPMediaQuery()
    query.addFilterPredicate( property )
    
    var items: [MPMediaItem] = query.items! as [MPMediaItem]
    
    return items[items.count - 1]
    
  }
  
}
