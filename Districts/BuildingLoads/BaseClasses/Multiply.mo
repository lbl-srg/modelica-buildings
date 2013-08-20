within Districts.BuildingLoads.BaseClasses;
block Multiply
  "Block that implements the multiplication for the linear regression"
  extends Districts.BuildingLoads.BaseClasses.PartialRegression;
  Modelica.Blocks.Interfaces.RealInput beta[nY+nU*nY]
    "Vector with regression coefficients"
  annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}),           iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));

protected
  parameter Integer os = nY+1 "Offset for building the matrix";
  Real y[nY] "Output vector";
algorithm
 // Compute y = beta0 + beta1 * u
 y := beta[1:nY] + {beta[os     :os+  nU-1],
                    beta[os+  nU:os+2*nU-1],
                    beta[os+2*nU:os+3*nU-1],
                    beta[os+3*nU:os+4*nU-1],
                    beta[os+4*nU:os+5*nU-1],
                    beta[os+5*nU:os+6*nU-1],
                    beta[os+6*nU:os+7*nU-1],
                    beta[os+7*nU:os+8*nU-1],
                    beta[os+8*nU:os+9*nU-1]} * {TOut, TDewPoi, HDirNor, HDif};
 QCoo    := y[1];
 QHea    := y[2];
 PLigInd := y[3];
 PPlu    := y[4];
 PFan    := y[5];
 PDX     := y[6];
 PLigOut := y[7];
 PTot    := y[8];
 PGas    := y[9];

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-80,50},{68,-28}},
          lineColor={0,0,255},
          textString="y=A+B*u")}), Diagram(coordinateSystem(preserveAspectRatio=
           false, extent={{-100,-100},{100,100}}), graphics),
          Documentation(info="<html>
This block implements the matrix-vector multiplication of
<a href=\"modelica://Districts.BuildingLoads.BaseClasses.LinearRegression\">
Districts.BuildingLoads.BaseClasses.LinearRegression</a>.
</html>", revisions="<html>
<ul>
<li>
April 22, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Multiply;
