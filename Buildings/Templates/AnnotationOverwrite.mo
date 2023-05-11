within Buildings.Templates;
model AnnotationOverwrite
  extends Modelica.Icons.Example;

  partial model InterfaceComponent
    replaceable SubComponentOption1 sub
      annotation(choices(
      choice(redeclare SubComponentOption1 sub),
      choice(redeclare SubComponentOption2 sub)));
  end InterfaceComponent;

  model ComponentOption1
    extends InterfaceComponent;
  end ComponentOption1;

  model ComponentOption2
    extends InterfaceComponent(
      redeclare replaceable SubComponentOption3 sub
      annotation(choices(
      choice(redeclare SubComponentOption3 sub))));
  end ComponentOption2;

  model SubComponentOption1
    parameter Integer flag=1;
  end SubComponentOption1;

  model SubComponentOption2
    parameter Integer flag=2;
  end SubComponentOption2;

  model SubComponentOption3
    parameter Integer flag=3;
  end SubComponentOption3;

  model Template
    replaceable ComponentOption2 comp;
  end Template;

  Template template annotation(Dialog(group="Test"));
end AnnotationOverwrite;
