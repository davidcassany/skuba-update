#!/usr/bin/env bash

# Copyright (c) 2019 SUSE LLC. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -xe

add_package_to_need_reboot() {
    echo "$1" >> /etc/zypp/needreboot.d/"$1"
}

add_repository() {
    zypper ar -f --no-gpgcheck "/suse/artifacts/repos/$1" "$1"
}

refresh_repository() {
    zypper ref -f -r "$1"
}

install_package() {
    zypper -n in -r "${1:-base}" "${2:-caasp-test}"
}

zypper_patch() {
    zypper --no-refresh --non-interactive-include-reboot-patches patch -r "$1" -y
}

check_test_package_version() {
    caasp-test | grep "CaaSP test version $1"
}

check_reboot_needed_present() {
    [ -f /var/run/reboot-needed ]
}

check_reboot_needed_absent() {
    [ ! -f /var/run/reboot-needed ]
}
