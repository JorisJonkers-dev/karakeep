# Changelog

## [1.1.6](https://github.com/JorisJonkers-dev/karakeep/compare/v1.1.5...v1.1.6) (2026-11-10)


### Bug Fixes

* **deps:** update getmeili/meilisearch docker tag to v1.56.0 ([#32](https://github.com/JorisJonkers-dev/karakeep/issues/32)) ([ee1e440](https://github.com/JorisJonkers-dev/karakeep/commit/ee1e440d54ce02692ea301ed859a99644889d96e))
* **deps:** update getmeili/meilisearch docker tag to v1.56.1 ([#37](https://github.com/JorisJonkers-dev/karakeep/issues/37)) ([9d42a2c](https://github.com/JorisJonkers-dev/karakeep/commit/9d42a2c07e1045d93127b763b999f9a366ecec4e))

## [1.1.5](https://github.com/JorisJonkers-dev/karakeep/compare/v1.1.4...v1.1.5) (2026-11-02)


### Bug Fixes

* **deploy:** reserve what karakeep-search uses ([#29](https://github.com/JorisJonkers-dev/karakeep/issues/29)) ([95c5211](https://github.com/JorisJonkers-dev/karakeep/commit/95c52113fe195006603cf733fc2bd19fdf3db5f8))

## [1.1.4](https://github.com/JorisJonkers-dev/karakeep/compare/v1.1.3...v1.1.4) (2026-11-01)


### Bug Fixes

* **deploy:** size karakeep and its search to what they use, and move the index off the cordoned Pi ([#27](https://github.com/JorisJonkers-dev/karakeep/issues/27)) ([681b8a2](https://github.com/JorisJonkers-dev/karakeep/commit/681b8a265e896f802a5cb2537114e552d7a99663))

## [1.1.3](https://github.com/JorisJonkers-dev/karakeep/compare/v1.1.2...v1.1.3) (2026-11-01)


### Bug Fixes

* **deploy:** request what karakeep-chrome uses, so it schedules beside the datastores ([#25](https://github.com/JorisJonkers-dev/karakeep/issues/25)) ([1a3fd23](https://github.com/JorisJonkers-dev/karakeep/commit/1a3fd2315131266e4e875aa0caf2df0b3d849688))

## [1.1.2](https://github.com/JorisJonkers-dev/karakeep/compare/v1.1.1...v1.1.2) (2026-10-22)


### Bug Fixes

* meilisearch upgrades its index on start, so a version bump no longer crash-loops it ([#18](https://github.com/JorisJonkers-dev/karakeep/issues/18)) ([f5dc0b3](https://github.com/JorisJonkers-dev/karakeep/commit/f5dc0b3c2d727b0f68a6c886dac9cde8c5248404))

## [1.1.1](https://github.com/JorisJonkers-dev/karakeep/compare/v1.1.0...v1.1.1) (2026-10-21)


### Miscellaneous Chores

* Renovate alone updates dependencies, so Dependabot's fallback goes ([#15](https://github.com/JorisJonkers-dev/karakeep/issues/15)) ([d9771c3](https://github.com/JorisJonkers-dev/karakeep/commit/d9771c32ed0ef6f0ee4028d1d28b9e4b262618ce))

## [1.1.0](https://github.com/JorisJonkers-dev/karakeep/compare/v1.0.1...v1.1.0) (2026-10-21)


### Features

* the images lock records each image's upstream version, and an upstream bump releases ([#10](https://github.com/JorisJonkers-dev/karakeep/issues/10)) ([40a1ebd](https://github.com/JorisJonkers-dev/karakeep/commit/40a1ebd1024fb2fa5638e83212df54129aa88500))

## [1.0.1](https://github.com/JorisJonkers-dev/karakeep/compare/v1.0.0...v1.0.1) (2026-10-18)


### Miscellaneous Chores

* release karakeep again, so its held chrome Canary runs under the longer deadline ([#5](https://github.com/JorisJonkers-dev/karakeep/issues/5)) ([ac49283](https://github.com/JorisJonkers-dev/karakeep/commit/ac49283205a31bc279264c5e9bacfb88908a6a4f))

## 1.0.0 (2026-10-17)


### Features

* karakeep, chrome and meilisearch under the restricted posture, with karakeep's state in Garage, and its Project Intent ([b06b2ad](https://github.com/JorisJonkers-dev/karakeep/commit/b06b2ad6881d5c3c206ab7213a9d4da5f9d215fb))
