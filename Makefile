
#adapted from https://medium.com/@andrewvetovitz/grpc-c-introduction-45a66ca9461f

LDFLAGS = -L/usr/local/lib `pkg-config --libs protobuf grpc++`\
           -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed\
           -ldl

CXX = g++
CPPFLAGS += `pkg-config --cflags protobuf grpc`
CXXFLAGS += -std=c++11

GRPC_CPP_PLUGIN = grpc_cpp_plugin
GRPC_CPP_PLUGIN_PATH ?= `which $(GRPC_CPP_PLUGIN)`

all: client server

client: mathtest.pb.o mathtest.grpc.pb.o client.o
	$(CXX) $^ $(LDFLAGS) -o $@					# $@ takes name of command (client)

server: mathtest.pb.o mathtest.grpc.pb.o server.o
	$(CXX) $^ $(LDFLAGS) -o $@
#building buffer files
%.grpc.pb.cc: %.proto
	protoc --grpc_out=. --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<

%.pb.cc: %.proto
	protoc --cpp_out=. $<

clean:
	rm -f *.o *.pb.cc *.pb.h client server