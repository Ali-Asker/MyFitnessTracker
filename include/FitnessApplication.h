#pragma once

#include <QtWidgets/QMainWindow>
#include "ui_FitnessApplication.h"

class FitnessApplication : public QMainWindow
{
    Q_OBJECT

public:
    FitnessApplication(QWidget *parent = nullptr);
    ~FitnessApplication();

private:
    Ui::FitnessApplicationClass ui;
};

