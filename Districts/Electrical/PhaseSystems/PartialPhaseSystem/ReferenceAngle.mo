within Districts.Electrical.PhaseSystems.PartialPhaseSystem;
type ReferenceAngle "Reference angle for connector"
  extends SI.Angle;

  function equalityConstraint
    input ReferenceAngle theta1[:];
    input ReferenceAngle theta2[:];
    output Real[0] residue "No constraints";
  algorithm
    for i in 1:size(theta1, 1) loop
      assert(abs(theta1[i] - theta2[i]) < Modelica.Constants.eps, "angles theta1 and theta2 not equal over connection!");
    end for;
  end equalityConstraint;
end ReferenceAngle;
