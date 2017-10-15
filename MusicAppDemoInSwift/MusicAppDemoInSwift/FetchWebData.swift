//
//  FetchWebData.swift
//  MusicAppDemoInSwift
//
//  Created by Chengzhi Jia on 15/11/20.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

import UIKit
import Alamofire

class FetchWebData: NSObject {
    var resourceArray, titleArray: [String]
    var dataArray = [String]()
    var imageArray = [UIImage]()
    
    override init() {
        self.resourceArray = ["https://itunes.apple.com/us/rss/topsongs/limit=25/json",
            "https://itunes.apple.com/us/rss/topmovies/limit=25/genre=4401/json",
            "https://itunes.apple.com/us/rss/topfreeebooks/limit=25/json",
            "https://itunes.apple.com/us/rss/topmusicvideos/limit=25/json",
            "https://itunes.apple.com/us/rss/toppodcasts/limit=25/json",
            "https://itunes.apple.com/us/rss/topfreeapplications/limit=25/json",
            "https://itunes.apple.com/us/rss/topaudiobooks/limit=25/json",
            "https://itunes.apple.com/us/rss/toptvepisodes/limit=25/genre=4003/json",
            "https://itunes.apple.com/us/rss/topitunesucollections/limit=25/json"]
        self.titleArray = ["Top Songs", "Top Movies", "Top eBooks", "Top Music Videos", "Top podcasts", "Top Apps", "Top AudioBooks", "Top Episodes", "Top iTunesU"]
    }
    
    func fetchMainData(index: Int) {
        Alamofire.request(.GET, self.resourceArray[index]).responseJSON { (Response) -> Void in
            if let dic = (Response.result.value!.objectForKey("feed")?.objectForKey("entry")) as? Array<AnyObject> {
                for detail: AnyObject in dic {
                    if let title = detail.objectForKey("title")?.objectForKey("label") as? String {
                        self.dataArray.append(title)
                    }
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName("secondReload", object: self)
        }
        
    }

}
