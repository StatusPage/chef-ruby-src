name              "ruby-src"
maintainer        "https://www.statuspage.io"
maintainer_email  "scott@statuspage.io"
license           "Apache 2.0"
description       "Installs system ruby from source"
version           "1.0.0"
recipe            "ruby-src", "Installs system ruby from source."

%w{ ubuntu debian }.each do |os|
  supports os
end
