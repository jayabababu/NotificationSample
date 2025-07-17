//
//  ViewController.swift
//  NotificationSample
//
//  Created by apple on 17/07/25.
//

import UIKit
import UserNotifications

class ViewController: UIViewController,UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white

                // Request permission once
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    print(granted ? "✅ Permission granted" : "❌ Permission denied")
                }
        UNUserNotificationCenter.current().delegate = self
                setupButtonGrid()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound]) // show banner and play sound even when app is open
    }
    func setupButtonGrid() {
            let titles = ["1", "2", "3", "4"]
            let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange]
            var buttons: [UIButton] = []

            for i in 0..<4 {
                let button = UIButton(type: .system)
                button.setTitle(titles[i], for: .normal)
                button.backgroundColor = colors[i]
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                button.layer.cornerRadius = 12
                button.tag = i + 1
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                view.addSubview(button)
                buttons.append(button)
            }

            NSLayoutConstraint.activate([
                buttons[0].topAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
                buttons[0].trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
                buttons[0].widthAnchor.constraint(equalToConstant: 120),
                buttons[0].heightAnchor.constraint(equalToConstant: 60),

                buttons[1].topAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
                buttons[1].leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
                buttons[1].widthAnchor.constraint(equalToConstant: 120),
                buttons[1].heightAnchor.constraint(equalToConstant: 60),

                buttons[2].topAnchor.constraint(equalTo: buttons[0].bottomAnchor, constant: 20),
                buttons[2].trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
                buttons[2].widthAnchor.constraint(equalToConstant: 120),
                buttons[2].heightAnchor.constraint(equalToConstant: 60),

                buttons[3].topAnchor.constraint(equalTo: buttons[1].bottomAnchor, constant: 20),
                buttons[3].leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
                buttons[3].widthAnchor.constraint(equalToConstant: 120),
                buttons[3].heightAnchor.constraint(equalToConstant: 60),
            ])
        }

        // MARK: - Button Action

        @objc func buttonTapped(_ sender: UIButton) {
            let buttonNum = sender.tag
            print("Button \(buttonNum) tapped")

            // Send local notification
            triggerNotification(for: buttonNum)

            let alert = UIAlertController(title: "Tapped", message: "Button \(buttonNum) tapped", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    func triggerNotification(for button: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Notification \(button)"
        content.body = "You tapped button \(button)"

        // Custom sound
        let soundName = UNNotificationSoundName("sound\(button).wav")
        content.sound = UNNotificationSound(named: soundName)

        // Trigger as fast as possible
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

        let request = UNNotificationRequest(identifier: "local_\(button)",
                                            content: content,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling: \(error.localizedDescription)")
            } else {
                print("✅ Notification \(button) triggered.")
            }
        }
    }

}

