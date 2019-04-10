within ;
model TestSingleZone
  Real x(start=-5);
  SingleZone sinZon(
  Core_ZN_xTest = x,
  Core_ZN_mInlets_flow =        0,
  Core_ZN_QGaiRad_flow =       0,
  Core_ZN_T =        20,
  X =        0.01,
  Core_ZN_TAveInlet =        20,
  Core_ZN_X =        0.01)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  when initial() then
    x = 5;
       elsewhen
            time >= 60 then
    x = 10;
  end when;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestSingleZone;
