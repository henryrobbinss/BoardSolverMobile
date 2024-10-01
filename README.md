# Board Solver Mobile

Board Solver Mobile (BSM) is a mobile aplication which leverages computer vision to solve for optimal next moves in common board games. BSM is built using an object detection model trained in *CreateML* based on *YOLOv2*. BSM currently supports Connect4 with future plans to add more!

## Table of Contents

* [Project Overview](#ProjectOverview)
* [Features](#Features)
* [Requirements](#Requirements)
* [Contributing](#Contributing)
* [License](#License)
* [Contributers](#Contributers)

## Project Overview

Do you ever get stuck trying to decide on your next move in a board game?  Board Solver Mobile (BSM), aims to be your assistant for strategic board games.  Leveraging the power of computer vision, BSM analyzes game states through your iOS device's camera and suggests the next optimal move based on pre-trained algorithms.

BSM currently supports the popular game of Connect4, with hopes to support more games in the future.  For each game, BSM considers various factors like piece placement, potential threats, and strategic goals to recommend the move with the highest chance of success.  The difficulty level of the solver currently only returns the best move, but we plan to make the diffculty of the opponent be adjustable, allowing you to test your skills against a range of challenges.

This project is a great tool for both casual and experienced board game players.  Whether you're looking for a helping hand to improve your game or simply want to explore different strategic options, BSM can be your guide to becoming a board game champion!

## Features

* Support for Connect4
* Pre-trained YOLOv2 model trained on custom data
* Support for iOS 17+

## Requirements

#### Development Environment
* Operating System: macOS (latest version recommended)
* Swift: [Current Swift version] (can be found at https://swiftversion.net/)
* Xcode: [Current Xcode version] (can be found at https://developer.apple.com/xcode/)

#### Hardware
* Any Mac supporting most recent Xcode and Swift versions
* iPhone (any model supported by the current iOS version)

## Contributing

We welcome contributions from the community! Here's how you can get involved with this project:

#### Forking the Repository
Fork this repository by clicking the "Fork" button on GitHub. This creates your own copy of the codebase.
Clone your forked repository to your local machine. You can use the following command in your terminal:
```
git clone https://github.com/henryrobbinss/BoardSolverMobile.git
```

#### Making Changes
Create a new branch for your feature or bug fix. You can use a descriptive branch name that reflects your changes. For example:
```
git checkout -b fix/camera-permissions
```
Make your changes to the codebase.
Commit your changes with a clear and concise commit message. A good commit message should describe what you changed and why.
Push your changes to your forked repository on GitHub.

#### Submitting a Pull Request (PR)
Navigate to your forked repository on GitHub.
Click on the "Pull requests" tab.
Click the button to "Create pull request".
In the pull request description, provide a detailed explanation of your changes and how they address any issues or improve the project.
Select the branch you want to merge your changes into (usually the main branch).
Click "Create pull request" to submit your contribution for review.

#### Review Process

We will review your pull request carefully. We may ask for clarifications or suggest modifications to your code. Please be patient and responsive during the review process.

#### Blessed Repo Format

This project follows the "blessed repo" contribution model. This means that only maintainers can directly push code to the main repository.  However, your contributions are highly valued!  By following these guidelines and submitting a pull request, you allow maintainers to review your code and integrate it into the main repository if it meets the project's standards.

#### Additional Notes

Before submitting a large pull request, consider creating a smaller, focused pull request for easier review.
We recommend following the project's coding style guide (if one exists) to ensure consistency in the codebase.
Feel free to ask questions or discuss your ideas by creating an issue on the project's GitHub repository.
We appreciate your contribution to Board Solver Mobile!

## License

This project is licensed under the GNU General Public License v2.0 (GPLv2). You can find a copy of the license [here](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html).  The GPLv2 grants you the freedom to use, modify, and distribute this software, while requiring you to share any modifications you make under the same license.

## Contributors
<a href="https://github.com/henryrobbinss/BoardSolverMobile/graphs/contributors" target="_blank">
  <img src="https://contrib.rocks/image?repo=henryrobbinss/BoardSolverMobile" />
</a>
