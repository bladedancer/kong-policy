package policyservice

import (
	"fmt"
	"net"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/reflection"
)

func (ps *PolicyServer) grpcServe(l net.Listener) error {
	var grpcServer *grpc.Server

	if ps.Config.CertFile != "" && ps.Config.KeyFile != "" {
		creds, err := credentials.NewServerTLSFromFile(ps.Config.CertFile, ps.Config.KeyFile)
		if err != nil {
			return fmt.Errorf("cert: [%s] key: [%s] error: %s", ps.Config.CertFile, ps.Config.KeyFile, err.Error())
		}
		log.Info("Starting GRPC over TLS")
		grpcServer = grpc.NewServer(grpc.Creds(creds))
	} else {
		log.Info("Starting GRPC over HTTP")
		grpcServer = grpc.NewServer()
	}

	reflection.Register(grpcServer)
	RegisterPolicyServerServer(grpcServer, ps)
	return grpcServer.Serve(l)
}
