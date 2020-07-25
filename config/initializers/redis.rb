REDIS_URL = ENV['REDIS_URL'] || "redis://127.0.0.1"
REDIS_PORT = ENV['REDIS_PORT'] || 6379

Redis.current = Redis.new(url: REDIS_URL,
                          port: REDIS_PORT)
