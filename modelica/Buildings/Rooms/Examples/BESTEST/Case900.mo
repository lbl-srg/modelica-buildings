within Buildings.Rooms.Examples.BESTEST;
model Case900 "Case 900 heavy mass test"
  extends Case600(matExtWal = extWallCase900,
                  matFlo =    floorCase900);
    Buildings.HeatTransfer.Data.OpaqueConstructions.Generic extWallCase900(
    nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.009,
        k=0.140,
        c=900,
        d=530,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.0615,
        k=0.040,
        c=1400,
        d=10,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.100,
        k=0.510,
        c=1000,
        d=1400,
        nStaRef=nStaRef)}) "High Mass Case: Exterior Wall"
    annotation (Placement(transformation(extent={{32,50},{46,64}})));
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic floorCase900(final nLay=
           2,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=1.007,
        k=0.040,
        c=0,
        d=0,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.080,
        k=1.130,
        c=1000,
        d=1400,
        nStaRef=nStaRef)}) "High Mass Case: Floor"
    annotation (Placement(transformation(extent={{60,50},{74,64}})));

  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/BESTEST/Case900.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the basic test case 900 of the BESTEST validation suite.
Case 900 is a heavy-weight building with room temperature control set to
<i>20&deg;C</i> for heating and <i>27&deg;C</i> for cooling.
The room has no shade and a window that faces south.
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Case900;
