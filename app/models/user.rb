class User < ApplicationRecord
    enum role: { admin: 0, waiter: 1, chef:2 }
end
