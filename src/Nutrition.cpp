#include "Nutrition.h"
#include <QDateTime>
#include <QDebug>
#include <string>
using namespace std;

namespace {
// Helper method to convert enum to string
const char *toString(MealType type)
{
    switch (type) {
    case MealType::Breakfast:
        return "Breakfast";
    case MealType::Lunch:
        return "Lunch";
    case MealType::Dinner:
        return "Dinner";
    case MealType::Snack:
        return "Snack";
    }
    return "Unknown";
}
} // namespace

// Constructor implementation for Nutrition class, initializing all attributes
// including those inherited from Log and the specific attributes of Nutrition.
// protein, carbs, fats, sugar, and title are optional and default to 0 / "".
Nutrition::Nutrition(const std::string &logID,
                     const QDateTime &date,
                     const std::string &description,
                     double duration,
                     MealType mealType,
                     double caloriesConsumed,
                     double protein,
                     double carbs,
                     double fats,
                     double sugar,
                     const std::string &title)
    : Log(logID, date, duration, description)
    , mealType(mealType)
    , caloriesConsumed(caloriesConsumed)
    , protein(protein)
    , carbs(carbs)
    , fats(fats)
    , sugar(sugar)
    , title(title)
{}

// computeImpact returns a negative value — calorie intake reduces net fitness impact.
double Nutrition::computeImpact() const
{
    return -caloriesConsumed;
}

// displayLog prints all nutrition details including macros.
void Nutrition::displayLog() const
{
    qDebug() << "Nutrition[title=" << title.c_str()
    << ", mealType=" << toString(mealType)
    << ", caloriesConsumed=" << caloriesConsumed
    << ", protein=" << protein << "g"
    << ", carbs=" << carbs << "g"
    << ", fats=" << fats << "g"
    << ", sugar=" << sugar << "g"
    << ", impact=" << computeImpact() << "]";
}

// Getters 
MealType Nutrition::getMealType() const       { return mealType; }
double   Nutrition::getCaloriesConsumed() const { return caloriesConsumed; }
double   Nutrition::getProtein() const        { return protein; }
double   Nutrition::getCarbs() const          { return carbs; }
double   Nutrition::getFats() const           { return fats; }
double   Nutrition::getSugar() const          { return sugar; }

const std::string &Nutrition::getTitle() const { return title; }

// Setters
void Nutrition::setMealType(MealType mealType)
{
    this->mealType = mealType;
}

void Nutrition::setCaloriesConsumed(double caloriesConsumed)
{
    this->caloriesConsumed = caloriesConsumed;
}

void Nutrition::setProtein(double protein) { this->protein = protein; }
void Nutrition::setCarbs(double carbs)     { this->carbs   = carbs;   }
void Nutrition::setFats(double fats)       { this->fats    = fats;    }
void Nutrition::setSugar(double sugar)     { this->sugar   = sugar;   }

void Nutrition::setTitle(const std::string &title) { this->title = title; }

// Two Nutrition objects are equal if every attribute matches.
bool Nutrition::operator==(const Nutrition &other) const
{
    return mealType         == other.mealType
           && caloriesConsumed == other.caloriesConsumed
           && protein          == other.protein
           && carbs            == other.carbs
           && fats             == other.fats
           && sugar            == other.sugar
           && title            == other.title;
}

// Stream insertion operator — formatted one-line summary.
ostream &operator<<(ostream &os, const Nutrition &nutrition)
{
    os << "Nutrition[title="    << nutrition.title
       << ", mealType="         << toString(nutrition.mealType)
       << ", caloriesConsumed=" << nutrition.caloriesConsumed
       << ", protein="          << nutrition.protein << "g"
       << ", carbs="            << nutrition.carbs   << "g"
       << ", fats="             << nutrition.fats    << "g"
       << ", sugar="            << nutrition.sugar   << "g"
       << ", impact="           << nutrition.computeImpact() << "]";
    return os;
}