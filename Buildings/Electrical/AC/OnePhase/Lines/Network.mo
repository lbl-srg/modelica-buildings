within Buildings.Electrical.AC.OnePhase.Lines;
model Network "Single phase AC network"
  extends Buildings.Electrical.Transmission.Base.PartialNetwork(
    redeclare Interfaces.Terminal_p terminal,
    redeclare replaceable Transmission.Grids.TestGrid2Nodes grid,
    redeclare Line lines(commercialCable_low=grid.cables, each use_C=use_C, each modelMode=modelMode));
  parameter Boolean use_C = false
    "Select if choosing the capacitive effect of the cable or not"
    annotation(Dialog(tab="Model", group="Assumptions"));
  parameter Buildings.Electrical.Types.Assumption modelMode=Types.Assumption.FixedZ_steady_state
    "Select between steady state and dynamic model"
    annotation(Dialog(tab="Model", group="Assumptions", enable = use_C), choices(choice=Buildings.Electrical.Types.Assumption.FixedZ_steady_state
        "Steady state", choice=Buildings.Electrical.Types.Assumption.FixedZ_dynamic "Dynamic"));
  Modelica.SIunits.Voltage Vabs[grid.Nnodes] "RMS voltage of the grid nodes";
equation
  for i in 1:grid.Nlinks loop
    connect(lines[i].terminal_p, terminal[grid.FromTo[i,1]]);
    connect(lines[i].terminal_n, terminal[grid.FromTo[i,2]]);
  end for;

  for i in 1:grid.Nnodes loop
    Vabs[i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal[i].v);
  end for;

  annotation (Icon(graphics={             Line(
          points={{-92,-60},{-72,-20},{-52,-60},{-32,-100},{-12,-60}},
          color={0,0,0},
          smooth=Smooth.Bezier)}));
end Network;
