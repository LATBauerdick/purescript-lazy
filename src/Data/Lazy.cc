///////////////////////////////////////////////////////////////////////////////
//
// Module      :  Lazy.cc
// Copyright   :  (c) Andy Arvanitis 2016
// License     :  MIT
//
// Maintainer  :  Andy Arvanitis <andy.arvanitis@gmail.com>
// Stability   :  experimental
// Portability :
//
// Lazy FFI functions
//
///////////////////////////////////////////////////////////////////////////////
//

#include "Lazy.hh"

namespace Data_Lazy {

  using namespace PureScript;

  // foreign import defer :: forall a. (Unit -> a) -> Lazy a
  //
  auto defer(const any& f) -> any {
    return [=]() -> any {
      static const any the_value = f(unit);
      return the_value;
    };
  }

  // foreign import force :: forall a. Lazy a -> a
  //
  auto force(const any& l) -> any {
    return l();
  }
}
