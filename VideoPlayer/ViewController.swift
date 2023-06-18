//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Jason Rich Darmawan Onggo Putra on 18/06/23.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVPlayerViewControllerDelegate {
    
    @IBOutlet weak var imageView_: UIImageView!
    
    @IBOutlet weak var avPlayerView_: UIImageView!
    
    private var avPlayer_: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Load the GIF image.
        //        let image = UIImage.gifImageWithURL("https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExOHIyZDR2bXBlNWNyNGxmdXZ2NnQyMW01eTY0cXFwdDc2cnJvODl2ZiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3orieS4jfHJaKwkeli/giphy.gif")
        let image = UIImage.gifImageWithName("giphy")
        imageView_.image = image
        
        // Load the video.
        //        guard let url = URL(string: "https://file-examples.com/wp-content/storage/2017/04/file_example_MP4_480_1_5MG.mp4") else { return }
        guard let url = Bundle.main.url(forResource: "file_example_MP4_480_1_5MG", withExtension: "mp4") else { return }
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        avPlayer_ = AVPlayer(url: url)
        
        // add AVPlayerLayer on top of AVPlayer View
        let layer = AVPlayerLayer(player: avPlayer_)
        layer.frame = avPlayerView_.bounds
        avPlayerView_.layer.addSublayer(layer)
        
        // Add tap gesture recognizer to the AVPlayer View
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avPlayerViewTapped))
        avPlayerView_.addGestureRecognizer(tapGesture)
        avPlayerView_.isUserInteractionEnabled = true
        
        // Handle if video did play to end time
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerItemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        avPlayer_?.play()
    }
    
    @objc private func avPlayerViewTapped(_ gesture: UITapGestureRecognizer) {
        guard let player = avPlayer_ else { return }
        
        // Create a new AVPlayerViewController and pass it a reference to the player
        let controller = AVPlayerViewController()
        controller.player = avPlayer_
        
        // Handle if user close the AVPlayerViewController modal.
        controller.delegate = self
        
        // Present the AVPlayerViewController modally
        present(controller, animated: true) {
            player.play()
        }
    }
    
    @objc private func avPlayerItemDidPlayToEndTime() {
        avPlayer_?.seek(to: CMTime.zero)
        avPlayer_?.play()
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        dismiss(animated: true) {
            self.avPlayer_?.play()
        }
    }
}

