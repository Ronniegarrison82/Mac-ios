#!/bin/bash
echo "📦 Updating CocoaPods..."
sudo gem install cocoapods
pod repo update
pod install || true