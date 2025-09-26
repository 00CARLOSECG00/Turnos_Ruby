require "sinatra"
require "json"
require "redis"
require "kafka"

# Conexión a Redis
redis = Redis.new(host: ENV["REDIS_HOST"] || "redis", port: 6379)

# Conexión a Kafka
kafka = Kafka.new(["kafka:9092"])
producer = kafka.async_producer

# POST /turnos → crea turno en Redis y lo publica en Kafka
post "/turnos" do
  data = JSON.parse(request.body.read)

  # Generar ID autoincremental
  id = redis.incr("turnos:counter")

  # Crear el turno
  turno = { id: id, cliente: data["cliente"], estado: "pendiente" }

  # Guardar en Redis
  redis.set("turno:#{id}", turno.to_json)

  # Enviar a Kafka (topic: turnos)
  producer.produce(turno.to_json, topic: "turnos")
  producer.deliver_messages

  content_type :json
  turno.to_json
end
