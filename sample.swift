import Foundation

func randomStory() -> String {
    let subjects = ["A wizard", "A ninja", "A robot", "A dragon", "A pirate"]
    let verbs = ["fought", "discovered", "built", "saved", "explored"]
    let objects = ["a secret scroll", "a mysterious land", "a futuristic city", "a magical realm", "a hidden treasure"]

    let subject = subjects.randomElement()!
    let verb = verbs.randomElement()!
    let object = objects.randomElement()!

    return "\(subject) \(verb) \(object)."
}

print(randomStory())
