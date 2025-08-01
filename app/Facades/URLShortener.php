<?php

namespace App\Facades;

use Illuminate\Support\Facades\Facade;

class URLShortener extends Facade
{
    protected static function getFacadeAccessor()
    { 
        return 'App\Services\URLShortenerService';
    }
}


