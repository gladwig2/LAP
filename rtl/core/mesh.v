package mesh;
parameter LAP_ALUWIDTH = 16;
parameter LAP_CMDWIDTH = 4;

typedef struct {
  logic [LAP_ALUWIDTH - 1:0] data;
  logic [LAP_CMDWIDTH - 1:0] cmd;
endinterface : dbus

endpackage;

