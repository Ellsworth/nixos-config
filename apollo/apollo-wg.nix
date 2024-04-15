{pkgs, ...}: {
  networking.wireguard.interfaces = let
    # [Peer] section -> Endpoint
    server_ip = "vega.kg5key.com";
  in {
    wg0 = {
      # [Interface] section -> Address
      ips = ["10.253.0.8/32"];

      # [Peer] section -> Endpoint:port
      listenPort = 51820;

      # Path to the private key file.
      privateKeyFile = "/home/erich/nixos-config/apollo/apollo-wg0.key";

      peers = [
        {
          # [Peer] section -> PublicKey
          publicKey = "u/iLQDIHNxt9T4Bdp2UioOrviCAPLJjoZgBnmvSFFgg=";
          presharedKeyFile = "/home/erich/nixos-config/apollo/apollo-wg0-preshare.key";
          allowedIPs = ["10.253.0.0/24"];
          endpoint = "${server_ip}:51820";
          persistentKeepalive = 300;
        }
      ];
    };
  };
}
