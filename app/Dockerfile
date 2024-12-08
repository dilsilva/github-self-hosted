FROM golang:1.23
WORKDIR /src

COPY <<EOF /src/server.go
package main
import "github.com/gin-gonic/gin"
func main() {
   app := gin.Default()
   router := app.Group("/")
   router.GET("/", Hello)
   app.Run(":80")
}
func Hello(c *gin.Context) {
  c.Writer.Write([]byte("<h1> hello ecs </h1>"))
}
EOF
RUN ls
RUN go mod init server
RUN go mod tidy
RUN go build -o hello
EXPOSE 80 

CMD ["/src/hello"]