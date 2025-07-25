<?php

namespace Modules\Payment\Facades;

use Illuminate\Support\Facades\Facade;

class Payment extends Facade
{
    protected static function getFacadeAccessor()
    { 
        return 'Modules\Payment\Services\PaymentService';
    }
}
