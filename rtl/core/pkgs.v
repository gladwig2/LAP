package proj_pkgs;

parameter LAP_ALUWIDTH = 16;
parameter LAP_CMDWIDTH = 4;

typedef struct packed{

  logic [LAP_ALUWIDTH - 1:0] data;
  logic [LAP_CMDWIDTH - 1:0] cmd;
} dbus_t;

endpackage;

