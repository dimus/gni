require 'digest/sha1'

module GNI
  class UUID
    def self.v5(namespace_uuid, str)
      return nil unless valid?(namespace_uuid)
      hex = namespace_uuid.gsub(/[\{\}-]/, '')
      to_hash = hex.to_a.pack('H*') + str
      hash = Digest::SHA1.hexdigest(to_hash)
      version_part = (hash[12..15].to_i(16) & 0x0fff) | 0x5000
      variant_part = (hash[16..19].to_i(16) & 0x3fff) | 0x8000
      "%08s-%04s-%04x-%04x-%12s" % [hash[0..7], hash[8..11], version_part, variant_part, hash[20..31]]
    end

    def self.valid?(uuid)
      !!/^\{?[0-9a-f]{8}\-?[0-9a-f]{4}\-?[0-9a-f]{4}\-?[0-9a-f]{4}\-?[0-9a-f]{12}\}?$/.match(uuid.downcase)
    end
  end
end
__END__
     public static function v5($namespace, $name) {
    if(!self::is_valid($namespace)) return false;

    // Get hexadecimal components of namespace
    $nhex = str_replace(array('-','{','}'), '', $namespace);

    // Binary Value
    $nstr = '';

    // Convert Namespace UUID to bits
    for($i = 0; $i < strlen($nhex); $i+=2) {
      $nstr .= chr(hexdec($nhex[$i].$nhex[$i+1]));
    }

    // Calculate hash value
    $hash = sha1($nstr . $name);

    return sprintf('%08s-%04s-%04x-%04x-%12s',

      // 32 bits for "time_low"
      substr($hash, 0, 8),

      // 16 bits for "time_mid"
      substr($hash, 8, 4),

      // 16 bits for "time_hi_and_version",
      // four most significant bits holds version number 5
      (hexdec(substr($hash, 12, 4)) & 0x0fff) | 0x5000,

      // 16 bits, 8 bits for "clk_seq_hi_res",
      // 8 bits for "clk_seq_low",
      // two most significant bits holds zero and one for variant DCE1.1
      (hexdec(substr($hash, 16, 4)) & 0x3fff) | 0x8000,

      // 48 bits for "node"
      substr($hash, 20, 12)
    );
  }
 
  end
end
