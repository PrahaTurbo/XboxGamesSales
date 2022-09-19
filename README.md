[![Swift 5.7](https://img.shields.io/badge/Swift-5.7-red)](https://swift.org/download/)
![UIKit](https://img.shields.io/badge/UIKit-blue)
[![@artlast](https://img.shields.io/badge/telegram-%40artlast-blue)](https://t.me/artlast)

# XboxGamesSales
![promo_gif](https://user-images.githubusercontent.com/62947475/191091902-4debfca0-93b4-40a1-af35-ba1add4f463e.gif)

## Table of Contents
* [General Info](#general-information)
* [Technologies Used](#technologies-used)
* [Features](#features)
* [Screenshots](#screenshots)
* [Requirements](#requirements)
* [Getting Started](#getting-started)

## General Information
App for checking discounts on Xbox in cheap regions. It's focused on Russian users because it has quick and easy currency convertion from region's currency to ruble. 

All the information for the app is taken from [psprices.com](https://psprices.com/) using html parsing.

For page menu, a third-party library [Parchment](https://github.com/rechsteiner/Parchment) is used. Using a ready-to-go solution rather than making it myself from scratch was more time-efficient.

## Technologies Used
* Swift 5.7
* UIKit
* Programmatic UI
* Parchment 3.1.0
* UserDefaults
* MVC

## Features
* All Xbox discounts in selected region
* Currency conversion to rubles
* Pull-to-refresh
* Infinite scrolling
* Redirect to Microsoft Store from a game info
* Custom error alerts

## Screenshots
<img src="https://user-images.githubusercontent.com/62947475/191092328-6e6ee300-1138-46c0-a63e-fac6edf0dff0.png" height="320"> <img src="https://user-images.githubusercontent.com/62947475/191092357-e4ba7e56-b8cd-4f31-9224-089a95accc30.png" height="320"> <img src="https://user-images.githubusercontent.com/62947475/191092365-e8710abb-0673-418e-8329-554fcc964fba.png" height="320"> <img src="https://user-images.githubusercontent.com/62947475/191092368-fd76a073-2051-4f5c-84bf-6c0cbce2f18e.png" height="320"> <img src="https://user-images.githubusercontent.com/62947475/191092349-ac7c1be7-e3c3-41ba-a41e-9bad1dd4968e.png" height="320">

## Requirements
* Xcode 13 or later
* iOS 14 or later

## Getting Started
* Clone or download
* Build and Run
